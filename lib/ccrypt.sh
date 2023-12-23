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
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D ]���K������2�~G��OҼ�` 9�݋�]�)�4�� �q׺M̕׽�$D%k���^��a%���T>�'�������Zj�Q�d%�فF��Cz��x����B4Ec��U�X�hGy|� V� WQ+�|atk�Y�_��aNfV��h�gD�NZ���
V�P�uE��T�_������P:BohwO�X���u���=��*Y��/`�S\!�����)��3��:�4�,#�9���\!=�o�*�D�c*0�K�ME��:8�����Y��n�W�!㑧΂^���p��̎1Ҷ����A�v�-���?�M���]�uO��9���'
C�$$��0̉�(�E~�%�-FX�7m�y���I q�O[�W��`�n����`!t��eL�xȳ��t�>�2�����e�V]DV�H�Ԭ �<�#��Y#1fL�"���Z\��3��Ǔ��.>A���Ǒsu��`/z����C�a���YC<��7���{�]���ب�r��VN_M��DG� ����I\/�*�?��>��4��*����a�pN��0�#IV�n!�����/tN�1�����kK)�q��0tQ,���i{ �����z\v�߾+v6�\?"��K>:aQp���lW� �22�
�ui"m�϶|�P�z!ե�T��U`���?%��+^~ap�7��fJ��i�Rb�eG!��6�ME�ً����ת�ʶ;`׏bb~�4%��<�4�}�����������B�y��ØLA`>c+50o�h~4U������^�Q0�_��(�8c��e��?!Emx�a�f�j��J-�����v�-�rkGX*�t�'�͞s�Hv��;�Z�!�V�����O0m�u���;�0�:92X��(�A߂x2��ه*��&L�NG�V�]:Eŝ �./��d�A֔�+6��1I���㽃� 1 p�6�,��8
�������9�_g5	i��������@�s������}Uk�P�lxL���|�ӥ�|BX���kڃ &�8[�K>jI��2ʢ�����9E�k.6LN�i:)�|刞E[�j,��f"������> ���MjZ&�N���yϫ?��A[7;Ҡ�Hc|7�,{�~�!&�[�٠T���qU>�U�G7ndk8Ȯ�?�r�Hq0�;zZ��kJ�=�!T������!5P9���/i@'=�]N9aE���M`��&Ǡ��q�;��*�����y �~T<m��v:���?�e-�B��|C��{3�MWI$��@+��)))ɘ�.��G�<�j]$�`�&�{��� ��Y��n �u����Hf���^;��Ľ\Y/�h퀪壚�C�!pJ��������s�O���:�.S�
6����>?�3]�[	Ԓ Js7�n�̮t�o���2��ܽ�5E��	�!�i/UW*0��.cD;���7���P%rCOy��)��L�٢|�i�|0L�$N�A�,tbP*�X�>Q���/�B�Gϑ���R����J%��`P��S�{97y\$w�
�{c����?r�y�8���S�������R�&����]�F�08V�c�V
�T[���=���5��$?�����c���I.]V��̩+Z񯓽�a�=��a��LW��f�rtR��Y��e"YR�X[��r���P�!Be��d".�J��ӑ�܌,�O�2]N?q�>!�.+��	���U) �X�	TMŻ)��	�� NZ�c��ڌ��zXdO��Z
�w����+T,�B n�GgŬD2�yX�<�d��a���9���N0���H9q�9�η��3��o�+<�!����L�\
������P���rX<�[��.��)�Ҏ���Ɓ
�>��p�7�x�i��7<��T�{���sps����-�(��MN|����-=�T!�)��6���}��]9�Ʈ���M���-�~x�g 	k��a�-��y����y��b�w^f1�@\�b��x��]�[��O����;��:ۅ����(=:��L�u�*B�O2i�m�Vc��g�3|E�y;l�J��g*�����CAj;[c�NT�?}��a��]O%k,Q~W,b�i��z!�"#M*��f�p7�J�P8h��Б�Dqq�����]k��L �EK��&�(��e���ozF`}T_�~�G�?�7��D��=3W��a=���BM: �礬���8N1

���z�t��L+���U��զnv��1�ް�*�"���]������o��Yg�Nκ������e#�b1��� ҉T���X��f����G��2%�'nSCx��a�)�(b��?^h��toD���p�CHQ!p/��1�5��Q�	�b�#H�Е�1�hސ<��~�K�x=�J�x�xM*���pOq�̉0_@| ,�k����%��¬��o�Ь)�� Ƴj��A]u�6�_�jK9�{�@{�Z��ܒ_[���!���[fm���Ә�*��E)��ʔ�]��I��6��*@6ר��=��_�wG ��Ư	|d�z�tpw1R�OeV��B[药�kd={.-�x���/�ge١��F*���H�o���*�zJ�L��q̺N�~�J�v�d����^K$^tCdƇU<*(�K��f2�.p2t�&rCX�
�!�Z�4�+h��qJ{��W�*��oA�~�ǰ��rx�9}�-n��H�eS��Hh�;��!����u����\��������b9�=7!�(A��Lʐ,uj��_u5ŏ-e/�\6~����G ʧנb!c��#�3b}�)1֒q����U ��tA#��q���7n�
�7+/J��`2���'Ͻ���M1�~dr(�� aL�\;q���	�����,��f*��I����c�l�� �O��ȓx[�z^�'L���*O�F�/o����XJӧj�ż�DB���U2H��#�׫,�-���<�8'�h���Z��d&#`��<ɼ��}�"�2�%��:^[�յ�|�g���.�& .&���fU,K]��r]��zr�Vfj�N$�X���2#�*��m�o2{"9�/�_}	,�f%.Z��A�Ֆ���`�3�B�K�
�u�����n�D*�H8��a�Ć��7=�9!Ԗ����<r��^�Od����5$�ʬ[�=v".�S�z��(�Ầ��M�dJ�8Lb�*ql��͡M� �1K%�f3��=�����������5Q�¸��ͅz��מo���L�j3��LW��(ĸ�<�O�~W;'a3��w9X�$d���H=��h4m+l耧�D��5���.^��O�b�u|m���s��P�c�j�f_`4RAP�9$�m����9�\Fr���@���c�����f�j-eE�Ծ9�Qv��ux�3�4��uC�s%�Uv�ƺ�ůpuL�M�-�Q����̵��;��O̟��]��B�V_��X�bS�wE�%t�7�����+7;'qD�|Z�Q,���d$'��hT�6��A��v��=�qOk��o�@E7�	�R��,{�������^Ls������ɾ'!Ӂo$��k���ý��!A��T�0������f���qZ���4�/5�/]�bA��� y�R#{�'P	�r*4�,���ץٽ�F��x $���P.N2��d!�y� kq�j�=j�"�'Q�M�yAX}&#�S��H����� �-ֱK#m2h��x�c�F��w]2���D�	5� �*��Y��~�7��M�VR�i�mh
?��Wt�zW�C1p��z�U��哸voP�v^�5��|��YF�l�zg�>�����5]qM���'�kT��9�M���E`����F+�@�;j��C��	��W%I�s$�@f��&4�. �4��$�j���$P�Qa8W�֟,9_,]l��G2�]��)� � ��������<����]r��/{dmWej}�d�u@%�4pF�M��D�pa�_���#Ua�/&O7�V9 