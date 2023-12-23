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
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D ��yA8�-��+�87�z�7�!�N-��h�����ҭ�0Z�U1p.�E�(��/]_�� �><@Ө9�k�w��l��z����#���n{������������'s��
���SF�(���z���؊8DbI����������|4K�Q1��"t��rNS3��55������(��U%g�EcD;ʜ���w9E~׊����F��0�B0����A~���?�����>�(B�Q�hӯm�X:�
S+�k��Ԡl�l���Zhe�R��T^�>�l�����T���$A��~$�mi�����u@dzm��Hc�����$,��XcwC J'�ND'�N�)*V�2A��P��^�VY����]�d���ݻ���V�� �恼(i �4S�-!���bb���HV@,�qF#���jV���|՟A��V��I<�R���ޮ>��o��"��x��
��L?��w��L����L<�4e+�Yۈ�%|.jVש&r� }g�
�`�9i� ����«��5��	2��6�8���	V�0S�����*io�뿛�_��5a�f}Op$�g{YV�9�O���+�qSUq*$��3�A�u��ҘeO�<���o�SoU!�nJ5t��q\���clM!�St!���+B�<i���Bc��Ϯ��QiK�k�vL����߂�RI\�ڈ�JM8`o
�V;/��KjB3�{��y�b�K�
���+��?�oB��ߠ�q�0��l����۬�أ\�ha�c�n�2=!�%��?հ��gxl9�H._���G+=%'��g9��2�Zxikjv�>Z}�C����J�]��O 1�q��6��;(��j�I)|]/����E���9��wk�>� ��c�"��C�tu��"�����4����$���cV��=%+:�<o���u��({��פ�i���伄Q*�'�.*XX����167�>pW}������6eL�G��QQ�Ao:,L��ɺ���7uz�D�� �В/�;��T{���$ƫ��Pj�n��i����C�b��@��\�k��%O�B&�^�h֮%�����5�'��KLuy��o�Fߔ��u�j�Oگ3Pܣ���j��^�X1:�Rϯ�m� �ƽ�-ӝ�E�s�:κD0�Y	qB��ׯ����b�0�`E�=�\��`����E�kkX�YJ�I�|�Kcu�����~�]d��)d�6$�)��x;G�Z�:v8Y��@�,v������M8�4�\�gi����$�ia=Z9�1j5L0��7WA���?3
����>Y~+��d�W_s��8j"O0��[�_d{k�w�br��ͶBO�g9���vo�>I���^|�]��hK'���	��?�S��bM$��Za5SKB���P1���\�pM�
U��h?��ƴ3���庖��Js,B{#�&�6P��ڛ1��������ҏ�7g��w�p���Fx���-�~��!���� B��}m1�P�>*�M8�6!yt���~���ϓy���wiK��js;��j�=#t�`l�DM>N�%d�^3�zX�6E�J�l~�~��M/��b�]��辶�c�` �2�9���
�N��>%t���#���r!|^`�*��:	�^����0K�FH# ���1�H O����>�����<V0oP���}����o����^J�s���-�rr4q
�Wq�֮Ab�6Xju#��\�o�19wj���������	��//m���.������hI��b�՟{_�B�
�}��x܀Ui�@�r��)Ut��e{���B�K<��g@����r	/�gc�W�q+I ��,:�
��.S{;:�޶ҟ���:{�ٴR���rk��R�9~&ղ��g���=������{�������4�tsY&ƾP�3�G�������\BP���^:��8�;���4em�ъ"�Fhb��:�����Yc,�^���J-�L@D�Z�+�2-�!.���k�R;K�ٺ�X�p�y�R��G��:���j~��@���z<�ڂ]M}����W@E�_���/�qn��,���.9���Hv��:ԯ�\O����J��~��D�5�b��ݙ����<lCUNl=n�8Ҁz����w�>Gm�� *����E�z�����~.����Х�K��p4S3ap}���q�gф�#�a@�hO�sL���p�y)ьVt%���ձ�κ����y'���K��Wv;��9.x���G��G���(�$����pNȘ��s�ɢ(�q�I8�(�}��6�@�����.j9s,g92�A����"�'��r�7���=4��[�ə�Bz�6�^~���7��|b�;�<�N��sV��I�+���o��'����ѐT�խWi�4���.�kiJ*�����}���.���<	���+�k�4�)��@�`}�&0�Jaa�\D˻�&�fW.�iC1o2����o)�?!��bS�F��V�(��w`���C��3��|��@�j��i�	�D�~��BL=�>��E����HcqC��-4hNGi�+��d����lS*��~��e�.�⥀�/������LI��o����B�NL����@�z����~�
(cM��*){�^ÕU��P�%1�	*�`-�m3?h��;Y<A-���{��#��}bnd�{�3����e�z]��:�`�?�zd۟��f]@)��΢�@^�"F�}{% ����JCj����{4�I�d�%���+�4���]�/X澍`��3�Vx`TJ�6!6<a����os[��ưZV5���p�>A{�R$�4����~G���eq�f[�7l����`���{��"҂<ʰW�1�P�,l+�T�bo	2��W�T�m��)��~�2c�����.��_�&(�6%��̄���7ϧ�����N�Vr�Tܳi)��Ꝍx�.���E����J���M�Y�l{ȴ�8<��	����"��W'ۣ�y.?�.��A9frZ����w�\=R{C�u��<d��kPWh2$6�C�i�8�:�#�.\ID*�d�sQ�x>��ɺI�52�}2̳��_��=�y���]S-]��V�E�\����x��C��Tʄ-�*xC��ԀI:Ѥ�}�ޮ�)ɻ8���6��*�����k�f �ذ`���F$�2t�H��R�{��S	jJ�b���������b�������`���FLM �6p���w�O�4�5�Ws=�1��I��F@���I1���S%M�.P�s�D��Cd�^ّixdW��{���� �����A����[�+�����+��1�o
�	�.myZ�C-��\�U�m�N!~�D[�F+�����F�=�Vpr�/��͙�>����+�@����?H�Z{��d)ːIb���\��c������7� ���mƍo늣�Ǿ�8cA���Y�QX�q�a�_G�k��iEݏ\T$���r�o&tw����l�7���O��H���s,_,_�m�/;����أuW�T@E�@��k`'=0C� 2�ΰ������y�65-/���io�2��2@Jr��0G8�U6�P"�q%m�V�6т�0� w�gѩ�Q4��j	���գXܳtA���޶(�BUG�.�L}��2�Zg�hYL	ۇ.PRx�s$�:�ey�l�Z7���zI��nS��^���<��4r�\��=���(e�Ā?�赭�r�"���V+9d�����&*�Ͱ;s�K��9�^�ۑ���YW	�/(���������"~��>��p��m�~�KdCܕo�)��,�?)#|O_iQ ,8_}�@GWc���_�ՁP��l`�$nPZ��J*�_$�9FVT}�?��s�����e�%=fy�N^������"w �v��{7 �*��f�bl]�NO1�]Z����Q(o���jŵ>#��]f%�1��L����� ���e�{���}oh/��L�T���R�vp3�Ş)������9?p��br?�i�ɳd[&���b0y.��M�R�C�wa�J��DB� ��R(k�7� 