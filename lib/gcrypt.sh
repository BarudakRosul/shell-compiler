#!/bin/bash
#
# Author: FajarKim (Rangga Fajar Oktariansyah)
# GitHub: https://github.com/FajarKim
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��D����k̅�LH}v�OP.�� �p1M�,�3T�S��`>� �^����RKuy0��!?�c}�6��[�|�,%�F�m�r�[ߠ��'�VG#�ϸ��H��x������O�
�&�F(+�R�f&8� F~�<�>��q݂.�x���'���B�f-'��پ֮�f�\d'�`ނ$��ߴ�j��H!�ҽx,�/m�˱e��M��/��A���Z��`�4H�3����/6H����eo=�7Ԝ,���jm�_��XB��HT�m��a�@F�@_@	Zo� z����dm��K`�g��5�ב���Y=�!�k�7k��X�W�$����B�h�BH�98�����f�,����u(��<�f�H��`LpЦ�yl�U�Ӹ��G��ޥ%�����)�"�[����0A�W��]���$�e哊��R{ai���ŉy,���}�B��נ�q������Y��3b�'W�� ��(s���S�خ�q~�n�O:�a��it^����Jn3�����2ؘNc��^,ܲ�-�'`,��z�����Z�����t9Z[7Pt?��Gf�{�J�47��Z��ws~R��YP�Y	�O Z��>�Z�zi��&�VM��ޯ� ��\�������8��)z�e�&�4���Hx���sw��x[�Z���<
��/�k�B�J�:;�y�g���a���Q�o�{"ăg�E��h��B�^�=uu�P�:Iy����fHUq��E���Ff	�ܶ!�����7f�lY�y�J\t.;��E|pסc㝝򎋻@�c����N���9J���X����9�|W�옪���f��*\\�f�b9�P_�#^m"��:`|G}0<�B���;�ztA�Kt�g.���9K��$e���F�R�T�C�+�^V�5��>����;/<DeQ
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D ��yfP]��+�87�z�7�!�N-��h�����ҭ�0Z�U1p.�E�(��/]_�� �><@Ө9�k�w��l��z����#���n{������������'s��
���SF�(���z���؊8DbI����������|4K�Q1��"t��rNS3��55������(��U%g�EcD\m*�gp����#�Q&���y���q��3=�9��$ʂ�����B݈�:��+�#_���z'OJ_e�E���CS�X�1�D8ٔ�,�@����	s�О�j1a���%m�P}c��v�|8b~@�U��p8"TT˪gs=�t��������)Q�Q���?�����o�)�<�7���Q
p���Y���`��j`[`��áA�ke@��� �t��p����Wf�;d��8��pi
��fn����a���hk8�,g4^f���Q�t��5,���&�E;h�7��j�_y�b��{A�9�5��ў�ß����0�H��%����O6���ɹ�G�bˡ��~Q+��\������ϯ���O����=�:�y\�Go�����v�9i|��u�n�7=��@\P�#������@c���<���}ʘ�u�uwG�}�#�˛9�ap@"Xa�E)��ŐZ�vt%��=|�E��@�c�k����b��_�1Zۢk[��$��uHy|�,3�r�W�}S�}���*	P���˲TI��U��&�`6k��N�C�>�սe��O  ��xÉ�Z�w	���E�cd!'����E>�����jR.rSxC��q��LE0�Ucۤ�7��x�S��!�/���(�k �	����g�1]Y�[c������q�u�f�s�u��5lq�g��&fJ,i�Xv❃�5��(�����5e�򝺻5,|%�����Z@�jr��g�IK&ͩe��"������3�3]|U���Fw�$	b:��T�|>�!�k�ЏN��� ��tёu�Wf��⾑��<��bsݱ�{�V;��\�ђ��v����Q�VQ����������ff����O���8�,��yM�yo����h�M�����}�����)�9ɛ�}?LTu�b�߻�����v*0�C�Ǳ-^G���R,��M���yM���D
�NM�o�$ �1��K.�Ug�f"M�=ߤ�R��vz�(f�uOMdB�5r_��E���|�r��g3b�F�Ot�O5M$�yΗ��50�Ʉ���s�Ii�W�Fi���r�s���L���+�
�����1;ֲ�[�S=�0֣i��e�@O��ȭ]���ի2�}u��_���]�}j1���C:��lT��i Fx6�6:�/��sg�p!��k���bۮ]�dW���p��1V��y��Sk�I\��'���r�΀��(j�V�\J6T�Bn�S�d�%R7��LD(^�˫߶�]��r�A�F�]6�6$��y:��Fcĝ�@�&h���9:^8�GE�a\����D�ލ9��e���ڸ�2l�}�������K�z#I�TM���iB�����*���ߖ��`,�^��Bu�JPR+�e��ؗǅ�����Uv�m��8ȹ���}��3�u��L�^{�RYdAV�/�K�X�fJfh%��֊�Gr"f-��4Q~�7�ly�|�q�/��S�^uD[.�_����|K�+\��8��:O��3��D*�_Ul1J�-0dJS'�&Y�x��8��7p����iM2=��Tť�g{�F�nBʂ6RZyH���b�XǱ�^���`��6��gvw=P �;�$�၁׋d����%�����Qx�l0�h�bK���ē+X�:��k���|��i#|' ����"�f���Fnott7q0�[�ts<�,G����*֗�ޮ6Ƞu�X��;���i'c+ɉ̒��W�$��h�+b�V��y�1bб�JKQ����\=�|RŒC�$�<�+**�����<�H�W�-�����g�L���v@��BL�'�V�x��y#lP'Š/.[��U��j���p�{���;|�����"����vm (��bqEN� c��z=�L:�L��U�WB3��[>���"�v�v� ��&8����%��ըθ���o0��,<�\���N���҉HÒ�4Z���7��2�O�(�P�'�3�$*�<H��Ǿ%�� \�.D��~�a�kHcc�O�׹4��	5���$;�(��r�S���L]�0|����Vh����$���#�hF^��4*M?'���>֚��dk�)��Eտ���R�h�Rq�ެ�+���aU��wL�<�&��<I$*KJ�<�m�n�V*���T�d�5K�\�Xg��V2��@-g����[�ֿ1)�_�THb��mj���D$ie錆�-*��A�|�Z�OY�CX���\&���4/��W.��E�>U�^Z�l�=����!	zk�p �����V{4A��g9�X�_P�q�����)Q�ʽ&I<����6\g��C���@N��Ri[�-/�e���F�.٧H�N|Jow�ʯ��M0-�-��~����/Y���"�`������86� )�z8CFv!1ͲWs�"}4��Q#����F�$��
,��M=�GFjVA�	^X89��m�B}��mÃ�G1���h�'�-�;�'��Ԭ{If��QyM�wHK%���N��Jq ݁$����[�[�� �|�q��i�h�s��׆)g;���M��ry*�Srz���pץ5��`Ɇ|s����(�����T؆W�gP�~��m�2O��':S,�!�	�	��
�M�m%:����r�M%��p��U@��E����6۟���b��/�7&1�O$bz8�J�$�϶1��c�C|�p���L<W\!����L��_��5���h? ���>���w��]j��ipd��r�.����(�+������X�;&�����?W!uq�)�����s�!�\��#�S��T��L�
6G�;��u\P�,�T,nzɅcj6e^#;+���9єlL����b�`x/��k�vOo�L<Z��NCa�h���GD�N5M��Y{N��F�`3	�G:З����M�ʙ]4)��ݕ^9���(�1N�鑘d�QÓ�����m�E{�أ�Ox���{)�"�F�pn�����!dn�h�X��K�q�?�X��@>�9��c�
�p��飪\\�e�Aه�o i�w.�QǗ�^��h;a���'�?�+v4��?퓦Z�m�-�h
]t� yAЍ�?J���ź\�뾳1A�*�H�{��m'E21���E���� b	�Q�\(w:$b�Y��q�D#cQߡ 9ޓ��0�ۤ��s�
�O�.n�ߋE�MBT��y<W	��U[�>:�Iq�-�S���Gi��-��#e�
'���]r��=siq򁮠E�V�#,i�82��P�!v/����Ŕ�����ہ�5.��%ɓ˻�z2I�U�՛�
��*4�:p�P^��������[��OD��xc�Z�X�Kc\P)���=uܗ5�K�놧T�ըO�E�ic7��R��?�.��@��;L�P�J�%����&[�����P)��Y�ova�����C����8E�rO�9�� ���J�w��ý� (J��|�jO�I��v,��j� Kw�eA�d��?�\����]XK�K�S!��0؁2ѷ�1�&z�k9EQoZ�t�ਗ��W�cRcM��d�<�|�ٶ!ں�`䋳FƘ����qZ�+�2�)�{����)"!��8̡��Pב��4t���a��0�ƆcZ��֔ɗ�{����*��'���F���6	�I������I�G�(!�J��MD�gQL���r�&�D��NQ6��h��&�/c��Y%�O,�mn�ׄ�����MT(K����Т�WkXa��'�ߝ�i��z]{O3l���� �nH��Ј�Yy*�x۶�^g�ǻ��BY����7}�����o��Ҥf��H`)�)��s�@\Lȟ�����u�Vs�x��C���7���c|�g.҅�7U~:��V�ʍ��)������YVoP���&