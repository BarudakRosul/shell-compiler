#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�?b����� �׏)�P��k�l`-�\��U���#+�lr�ͤ������,�3<N���@SP�DOL <���
�3��t)QՁ.4 �:����R;͈[��(a���������&�;IØ�e˻��a��l�Y;e(��Τ�������&��#���L���u==ʩo�e"��AN�^���֞�a��\��̷ j��N$�MٓP�!����`%��"_)z�,��� ������`��j�q�m5�����q[#�',5�����&Qa����v]Y (�P���49���ш�	/ā���n]�|x�r8n*�.�Lǂ(}���	�p���m��ϑ�݊[�Iwr�*
 ��T��m�4�!�)� F�]�'s@�B�y��0+~,�j-��
�����_U�W�I�c|��9T��SU��,�t���G]�UxB�8�L��I��M�c�#��ޠX�$�൛o�A��qsk��M�с�~�?9�%4z���k��~s�C+��:9�|�v��	�i,��-�nK����w��Hx�8�\kesy�.��
p�-�җ�1��`yH�%'Hqr�6�r_థh���U�b��(��]�
���ю�gy[�D��TǱ��Z����1	QM��QL8�`����FMtE�»Y�g��J�����}�H�[i��h6+G��O4;������Ab�e��o<A9��(i�Wߔ���'-V��/�	˹W���(8ߢ.g��^��I������~��YWл���\�筞�p��݂��T� �	��â�x���:��cS��$P�a)�7>��e��	1���I�3Mz�6ˤ�X����!���`T ����}�&���1|[�:ޝ�/�phW�Ǝ6^����|́
�F���_�>��X���ó�5�'2Z�	&�i�| G�g�<&�f�۩�ˣeM�ϒ����y	���f�=�/�Q���~�q��0���K��������I�8�Ӵ�m�d/�ov��}#ԒUD�zylǇ[��q����MB�SƦ+p�O;�6�)�={�sZp��A)�d��t�:�n�u\�
�\�6D��cfz�^�-8ƺ��Q����<���t���VݶAŮ��B�����!<�b3���{"�M��IzxFT^u� �i�>��K�Ђ�,�}��R,i�l�9_�4-�0�o��I=�{R��G��A��#q����[z���&r�x����_r2.R�±Lq��z� ���ZE�WӨ��V�k��8�E
���I	U�̆��@K_�ء�A]��B7.��4�F��젙PJ5��p� ��{�@����`ŏ���� q���Цҩp��W6�3R� M�H�z���;q�X�wcC�(h�(�~j��2P����jA"�81*��\:��[]���W��Î��"˝�܆!�,,��DIq\uN��U�Q���g�X[��n+��q�8[7I�HA�p�ȵR�h��e���%R�rP���Y73F6�J�U,��q�I�T<�|v��q��4�V����Z��\Vd�8/o���1�Y�~ቸ���V�n,+����YC\���J`cŔz�T�6}Ʉ"��"�����νa}���Nď�K2m��.qS�KŻ�W�	܉�"�u)e�i^���g,p1�̐�oE�6��8���;\��<��a��h�Z�A��l
w�'�r�Em��Z�w�o�6�u�����S1�b4(7�+���w�����
J�"c��'s$
�XL��<f�����$[���o���t���sU��c�xf(`
˗r"�G̕ ��LY!t���G�W��4���=�����aXƓ� Ok$W�k	�M�*;�/?�����H�8�Y�rr�n}M��i.[c"cۚo��9�����|)�Z�$��m㆖�ꒅa��	b�ud�ÿ^dJ�V�6k���t�+���U�@�GB]��>����أ�W�u�3��:���d�Z��l�j[�D/���}�;��<G�8���'n?fj�է�E������yA3N-Y�B3;upu����Ă?x=`V=1N]�} �e��ox򷙺�=��L�L�K$�BHl�v��ѭW�V�W*����yG���^:�"�ٵ� ����M������]�i�NB�!��k*���ey�P��F�M�	.�C���x YGQcH�~ʒ���s\Ӥ�AY�hЦit��5�^��]_^��U�z�]��cR�16~@M��ɖۤ�";��K���s$l����U9 ss��;�i��K��ǆ�#�`ײ9:ɔh�%�%��R;�I�����O=���������,-U�usRe�T�&�L�d	@uy����u���M#Lϴ,����]��GI#��hH��F~���SL&�}h�&�PD�Y�4���j�
|� 2(�0g	R� ��8�ع�*9�wozNA��
3B'�O��]���>u�Z�>{7�!��Ί���j~ny��>�b7DP:��,��	�6��Dew�$�hf�؈ޜ�w0Ϟ\�y@h���Ql�P�����:Wf�d��=z)�a�M}��^q�O�SP��
{0( p�ʝ��k[�ϟ�:]g�F��Ɖ��'UL���Ġ�~���<�z��G�B����5���b*����,P{듩�U��D�NML �KTh�`f���C�:&,G�z%�p���:�h梷�M�y��4S<�wH��ӺB�gW�A��r��`w�=DЫ�8�b{�����՚����U� l��G�t�2�jR��D�1;O�h�Q�_ X�)^�^x������w'
��M"]��A�h���n� �֪�J�T���>�{H��\՟���n�W�J7�U�k"s�ͣ�6S�v�(�~X;�� /xukK��o��(E:!^}v������{!�@���H�vd?Y@�� Iw�#Q{���)G�#�֝�:��	�|o�t����-�\ ��I����l�ϲg�yb���7cC.N�/�������VH9@�?��u�I B��R�� Ӹ��%(y��kj��)Lj塱	m�ڄ{T�Lu��R��÷��L����WHx��z�'�U���{q���1��mc��y?��E7T�ڄ43�����v���^�3��H�~�]Q꽌���3�O��v��CJ��׮9y.�ǿ�1�I�ʚiZ�� زժȺ�&��P����%�?��s�%D��ՎѱBaPGt;N��[)���:hH_����`"u�	>7ީ�ؖ|,��% z��a�2A_Q�.�Akk��*s���Lxr�>�oA��M�8q~G�����w/R�|�-��]#��pCh0�����uY��}Ʒ�T��y�YJvy`�o��Ӯ�����I�k�S�C��"Y �[�5?��F��� �6�9�u���:
��0'�סG����֗_TI�֏�~��0D.�rOD�9����>4Wou?=��i1 d��^x�5�M sa�$�/�/�g��c=�3^�9H݇����A�r�l�NAG�e��!�U|"e�Q�n���a0���� [�xz��lM�#b�����{IDh`�L�w�oJ��]���
�!�_M���X�} Ot�x�IT��S�����3�Y_e-�Ŭ#H���x��)r}S�W�E�hz�o��� �TcռKO3/�V0��a���ћ��>�k�Jx	w�D��?�����{�!U���g�ȳo��%��sF�Ae���?�T<�M9�T`,�@���Z�+��N��?z�"��.�r�<��]�l�y]��]:�M�]U�c���R�=������x��
+��q�ӫ_:Pg�~�pCPVMQ���D,kFF�����ܳb��#�4����k�H���#N�*����LCr��b�6ع�"5����CI-��ȸ%����7֙����-�Q4Ζҹ�o����T�����B`�ϥ�R����Q⯄������� Āh���>�pgn����Ug��֋�4���]�\��t��g�+9 Q��w�7䷁u���˚��-�ÿ�l�q�Ɔ��F;����5�?Fl��2�
����Dk�